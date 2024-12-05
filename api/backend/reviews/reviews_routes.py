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
reviews = Blueprint('reviews', __name__)

#------------------------------------------------------------
# Get all the reviews from the database
@reviews.route('/reviews', methods=['GET'])
def get_review():
    query = '''
        SELECT  id, 
                rating, 
                review, 
                student_id, 
                job_position_id
        FROM review
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of reviews
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
# Add a new review to the database
@reviews.route('/reviews', methods=['POST'])
def add_review():
    # Collecting data from the request object
    review_data = request.json
    current_app.logger.info(review_data)

    # Extracting the variables
    rating = review_data['rating']
    review = review_data['review']
    student_id = review_data['student_id']
    job_position_id = review_data['job_position_id']

    # Constructing the query
    query = f'''
        INSERT INTO review (rating, review, student_id, job_position_id)
        VALUES ('{rating}', '{review}', '{student_id}', '{job_position_id}')
    '''
    current_app.logger.info(query)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully added review")
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get information about a specific review
@reviews.route('/reviews/<id>', methods=['GET'])
def get_review_detail (id):

    query = '''
        SELECT  id, 
                rating, 
                review, 
                student_id, 
                job_position_id
        FROM review
        WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /reviews/<id> query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /reviews/<id> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response



# ------------------------------------------------------------
# Update a review in the database
@reviews.route('/reviews/<id>', methods=['PUT'])
def update_review():
    # Collecting data from the request object
    review_data = request.json
    current_app.logger.info(review_data)

    # Extracting the variables
    id = review_data['id']
    rating = review_data['rating']
    review = review_data['review']
    student_id = review_data['student_id']
    job_position_id = review_data['job_position_id']

    # Constructing the query
    query = f'''
        UPDATE review
        SET id = '{id}', rating = '{rating}', review = {review}, student_id = {student_id}, job_position_id = {job_position_id}
        WHERE id = {id}
    '''
    current_app.logger.info(query)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully updated review")
    response.status_code = 200
    return response



# ------------------------------------------------------------
# Delete a review from the database
@reviews.route('/reviews/<id>', methods=['DELETE'])
def delete_review(id):

    # Constructing the query
    query = f'''
        DELETE FROM review
        WHERE id = {id}
    '''
    current_app.logger.info(query)

    # Executing and committing the delete statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully deleted review")
    response.status_code = 200
    return response


#------------------------------------------------------------
# Retrieve a list of reviews for positions at a specific company
@reviews.route('/reviews/company/<company_id>', methods=['GET'])
def get_reviews_by_company(company_id):

    query = f'''
        SELECT r.id, r.rating, r.review, r.student_id, r.job_position_id, s.name as student_name
        FROM review r
        JOIN job_position jp ON r.job_position_id = jp.id
        JOIN company c ON jp.company_id = c.id
        JOIN student s ON r.student_id = s.id
        WHERE c.id = {str(company_id)}
    '''
    #Log query
    current_app.logger.info(f'GET /reviews/company/<company_id> query={query}')

    # Get a cursor object from the database
    cursor = db.get_db().cursor()

    # Execute the query
    cursor.execute(query)

    # Fetch all matching records
    theData = cursor.fetchall()

    # Create an HTTP response with the data
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response



# ------------------------------------------------------------
# Retrieve a list of reviews made by a specific student
@reviews.route('/reviews/student/<id>', methods=['GET'])
def get_reviews_by_student(id):

    query = f'''
        SELECT r.id, r.rating, r.review, r.student_id, r.job_position_id, s.name as student_name
        FROM review r
        JOIN job_position jp ON r.job_position_id = jp.id
        JOIN company c ON jp.company_id = c.id
        JOIN student s ON r.student_id = s.id
        WHERE s.id = {str(id)}
    '''
    #Log query
    current_app.logger.info(f'GET /reviews/student/<id> query={query}')

    # Get a cursor object from the database
    cursor = db.get_db().cursor()

    # Execute the query
    cursor.execute(query)

    # Fetch all matching records
    theData = cursor.fetchall()

    # Create an HTTP response with the data
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response
    


# ------------------------------------------------------------
# Retrieve a list of reviews about a specific job position
@reviews.route('/reviews/job-position/<id>', methods=['GET'])
def get_reviews_by_job_position(job_position_id):

    query = '''
        SELECT r.id, r.rating, r.review, r.student_id, r.job_position_id
        FROM review
        WHERE job_position_id = {str(job_position_id)}
    '''
    #Log query
    current_app.logger.info(f'GET /reviews/job-position/<id> query={query}')

    # Get a cursor object from the database
    cursor = db.get_db().cursor()

    # Execute the query
    cursor.execute(query)

    # Fetch all matching records
    theData = cursor.fetchall()

    # Create an HTTP response with the data
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response