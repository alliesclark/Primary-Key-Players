########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db



#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
students = Blueprint('students', __name__)

#------------------------------------------------------------
# Get all the students from the database, package them up,
# and return them to the client.
# Tested and works :)
@students.route('/students', methods=['GET'])
def get_students():
    query = '''
        SELECT  s.id, 
                s.name, 
                s.email, 
                s.gpa, 
                m.name AS major_name,
                s.grad_year,
                c.name AS advisor_name 
        FROM student s JOIN major m ON s.major_id = m.id JOIN coop_advisor c ON c.id = s.advised_by
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of students
    cursor.execute(query)

    # fetch all the data from the cursor
    # The cursor will return the data as a 
    # Python Dictionary
    theData = cursor.fetchall()

    # Create a HTTP Response object and add results of the query to it
    # after "jasonify"-ing it.
    response = make_response(jsonify(theData))
    # set the proper HTTP Status code of 200 (meaning all good)
    response.status_code = 200
    # send the response back to the client
    return response

# ------------------------------------------------------------
# Get student information about a specific student
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
# Tested and works :)
@students.route('/students/<id>', methods=['GET'])
def get_student_detail (id):

    query = f'''s.id, 
                s.name, 
                s.email, 
                s.gpa, 
                m.name AS major_name,
                s.grad_year,
                c.name AS advisor_name 
            FROM student s JOIN major m ON s.major_id = m.id JOIN coop_advisor c ON c.id = s.advised_by
            WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /students/<id> query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /students/<id> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get student information about a specific student
# notice that the route takes <major> and then you see major
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
# Tested and works :)
@students.route('/students/major/<major>', methods=['GET'])
def get_students_by_major (major):

    query = f'''SELECT id, 
                       name, 
                       email, 
                       gpa, 
                       major_id,
                       grad_year,
                       advised_by 
                FROM student 
                WHERE major_id = {str(major)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /students/major/<major> query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /students/major/<major> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get contact information about a specific student
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
# Tested and works :)
@students.route('/students/<id>/contact-info', methods=['GET'])
def get_student_contact (id):

    query = f'''SELECT id,
                       name, 
                       email 
                FROM student 
                WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /students/<id>/contact-info query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /students/<id>/contact-info Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Retrieve a list of students who previously had the specified job position
# Tested and works :)
@students.route('/students/job-position/<job_id>', methods=['GET'])
def get_students_by_job_position(job_id):

    query = f'''
        SELECT s.id, s.name, s.email, s.gpa, s.grad_year, s.major_id
        FROM student s
        JOIN student_past_job spj ON s.id = spj.student_id
        WHERE spj.job_position_id = {str(job_id)}
    '''

    # Get a cursor object from the database
    cursor = db.get_db().cursor()

    # Execute the query
    cursor.execute(query)

    # Fetch all matching records
    students_data = cursor.fetchall()

    # Create an HTTP response with the data
    response = make_response(jsonify(students_data))
    response.status_code = 200
    return response

#------------------------------------------------------------
# Add a new student to the database
@students.route('/students', methods=['POST'])
def add_student():
    # Collecting data from the request object
    student_data = request.json
    current_app.logger.info(student_data)

    # Extracting the variables
    name = student_data['name']
    email = student_data['email']
    gpa = student_data['gpa']
    major_id = student_data['major_id']
    grad_year = student_data['grad_year']
    advised_by = student_data['advised_by']

    # Constructing the query
    query = f'''
        INSERT INTO student (name, email, gpa, major_id, grad_year, advised_by)
        VALUES ('{name}', '{email}', {gpa}, {major_id}, {grad_year}, {advised_by})
    '''
    current_app.logger.info(query)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully added student")
    response.status_code = 200
    return response

#------------------------------------------------------------
# Update a student in the database
@students.route('/students/<id>', methods=['PUT'])
def update_student(student_id):
    student_data = request.json
    current_app.logger.info(student_data)

    name = student_data['name']
    email = student_data['email']
    gpa = student_data['gpa']
    major_id = student_data['major_id']
    grad_year = student_data['grad_year']
    advised_by = student_data['advised_by']

    query = f'''
        UPDATE student
        SET name = '{name}', email = '{email}', gpa = {gpa}, major_id = {major_id}, grad_year = {grad_year}, advised_by = {advised_by}
        WHERE id = {student_id}
    '''
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully updated student")
    response.status_code = 200
    return response


#------------------------------------------------------------
# Delete a student from the database
@students.route('/students/<student_id>', methods=['DELETE'])
def delete_student(student_id):
    
    query = f'''DELETE FROM student WHERE id = {student_id}
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    response = make_response(jsonify({'message': 'Student deleted'}))
    response.status_code = 200
    return response

#------------------------------------------------------------