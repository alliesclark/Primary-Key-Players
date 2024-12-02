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
job_position = Blueprint('job_position', __name__)

#------------------------------------------------------------
# Get all job positions from the database, package them up,
# and return them to the client
@job_position.route('/job_position', methods=['GET'])
def get_job_position():
    query = '''
        SELECT  id, 
                title, 
                description, 
                still_accepting, 
                num_applicants,
                postedAt,
                updatedAt,
                location,
                desired_skills,
                targeted_majors,
                company_id 
        FROM job_position
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of jobs
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
# Get job position information about a specific job
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
@job_position.route('/job_position/<id>', methods=['GET'])
def get_specific_job (id):

    query = f'''SELECT id, 
                       title, 
                       description, 
                       still_accepting, 
                       num_applicants,
                       postedAt,
                       updatedAt,
                       desired_skills,
                       targeted_majors,
                       company_id 
                FROM job_position 
                WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /job_position/<id> query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /job_position/<id> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get job position information about jobs targeting specific majors
# notice that the route accesses targeted_maors and then you see major
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
@job_position.route('/job-position/targeted-majors/<major_id>', methods=['GET'])
def get_jobs_by_major (major_id):

    query = f'''SELECT id, 
                       title, 
                       description, 
                       still_accepting, 
                       num_applicants,
                       postedAt,
                       updatedAt,
                       desired_skills,
                       targeted_majors,
                       company_id 
                FROM job_position 
                WHERE targeted_majors = {str(major_id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /job-position/targeted-majors/<major_id> query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /job-position/targeted-majors/<major_id> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get contact information about jobs that are within similar companies
@job_position.route('/job-position/similar-companies', methods=['GET'])
def get_similar_jobs ():

    query = f'''SELECT j.id,
                       j.title, 
                       j.description, 
                       j.still_accepting, 
                       j.num_applicants,
                       j.postedAt,
                       j.updatedAt,
                       j.desired_skills,
                       j.targeted_majors,
                       j.company_id 
                FROM job_position j JOIN company c ON j.company_id = c.id
                JOIN industry i ON c.industry = i.id
                GROUP BY j.company_id
    '''
    

    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /job-position/similar-companies query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /job-position/similar-companies Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response



# ------------------------------------------------------------
# Retrieve a list of previous jobs from a specific student
@job_position.route('/job-position/student/<id>', methods=['GET'])
def get_student_past_jobs(id):

    query = f'''SELECT  j.id, 
                        j.title, 
                        j.description, 
                        j.still_accepting, 
                        j.num_applicants,
                        j.postedAt,
                        j.updatedAt,
                        j.desired_skills,
                        j.targeted_majors,
                        j.company_id
                FROM job_position j JOIN student_past_job spj ON j.id = spj.job_position_id
                WHERE spj.student_id = {str(id)}
    '''

    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /job-position/student/<id> query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    students_data = cursor.fetchall()

    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /job-position/student/<id> Result of query = {theData}')

    # Create an HTTP response with the data
    response = make_response(jsonify(students_data))
    response.status_code = 200
    return response


#------------------------------------------------------------
# Post a new job position to the database
@job_position.route('/job-position', methods=['POST'])
def add_job_position():
    # Collecting data from the request object
    job_position_data = request.json
    current_app.logger.info(job_position_data)

    # Extracting the variables
    title = job_position_data['title']
    description = job_position_data['description']
    still_accepting = job_position_data['still_accepting']
    num_applicants = job_position_data['num_applicants']
    postedAt = job_position_data['postedAt']
    updatedAt = job_position_data['updatedAt']
    desired_skills = job_position_data['desired_skills']
    targeted_majors = job_position_data['targeted_majors']
    company_id = job_position_data['company_id']

    # Constructing the query
    query = f'''
        INSERT INTO job_position (title, description, still_accepting, num_applicants, postedAt, updatedAt,
                                    desired_skills, targeted_majors, company_id)
        VALUES ('{title}', '{description}', {still_accepting}, {num_applicants}, {postedAt}, {updatedAt},
                    '{desired_skills}', '{targeted_majors}', '{company_id}')
    '''
    current_app.logger.info(query)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully added student")
    response.status_code = 200
    return response

# # ------------------------------------------------------------
# # get product information about a specific product
# # notice that the route takes <id> and then you see id
# # as a parameter to the function.  This is one way to send 
# # parameterized information into the route handler.
# @students.route('/product/<id>', methods=['GET'])
# def get_product_detail (id):

#     query = f'''SELECT id, 
#                        product_name, 
#                        description, 
#                        list_price, 
#                        category 
#                 FROM products 
#                 WHERE id = {str(id)}
#     '''
    
#     # logging the query for debugging purposes.  
#     # The output will appear in the Docker logs output
#     # This line has nothing to do with actually executing the query...
#     # It is only for debugging purposes. 
#     current_app.logger.info(f'GET /product/<id> query={query}')

#     # get the database connection, execute the query, and 
#     # fetch the results as a Python Dictionary
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     theData = cursor.fetchall()
    
#     # Another example of logging for debugging purposes.
#     # You can see if the data you're getting back is what you expect. 
#     current_app.logger.info(f'GET /product/<id> Result of query = {theData}')
    
#     response = make_response(jsonify(theData))
#     response.status_code = 200
#     return response
    
# # ------------------------------------------------------------
# # Get the top 5 most expensive products from the database
# @students.route('/mostExpensive')
# def get_most_pop_products():

#     query = '''
#         SELECT product_code, 
#                product_name, 
#                list_price, 
#                reorder_level
#         FROM products
#         ORDER BY list_price DESC
#         LIMIT 5
#     '''
    
#     # Same process as handler above
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     theData = cursor.fetchall()
 
#     response = make_response(jsonify(theData))
#     response.status_code = 200
#     return response

# # ------------------------------------------------------------
# # Route to get the 10 most expensive items from the 
# # database.
# @students.route('/tenMostExpensive', methods=['GET'])
# def get_10_most_expensive_products():
    
#     query = '''
#         SELECT product_code, 
#                product_name, 
#                list_price, 
#                reorder_level
#         FROM products
#         ORDER BY list_price DESC
#         LIMIT 10
#     '''
    
#     # Same process as above
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     theData = cursor.fetchall()
    
#     response = make_response(jsonify(theData))
#     response.status_code = 200
#     return response
    

# # ------------------------------------------------------------
# # This is a POST route to add a new product.
# # Remember, we are using POST routes to create new entries
# # in the database. 
# @students.route('/product', methods=['POST'])
# def add_new_product():
    
#     # In a POST request, there is a 
#     # collecting data from the request object 
#     the_data = request.json
#     current_app.logger.info(the_data)

#     #extracting the variable
#     name = the_data['product_name']
#     description = the_data['product_description']
#     price = the_data['product_price']
#     category = the_data['product_category']
    
#     query = f'''
#         INSERT INTO products (product_name,
#                               description,
#                               category, 
#                               list_price)
#         VALUES ('{name}', '{description}', '{category}', {str(price)})
#     '''
#     # TODO: Make sure the version of the query above works properly
#     # Constructing the query
#     # query = 'insert into products (product_name, description, category, list_price) values ("'
#     # query += name + '", "'
#     # query += description + '", "'
#     # query += category + '", '
#     # query += str(price) + ')'
#     current_app.logger.info(query)

#     # executing and committing the insert statement 
#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     db.get_db().commit()
    
#     response = make_response("Successfully added product")
#     response.status_code = 200
#     return response

# # ------------------------------------------------------------
# ### Get all product categories
# @students.route('/categories', methods = ['GET'])
# def get_all_categories():
#     query = '''
#         SELECT DISTINCT category AS label, category as value
#         FROM products
#         WHERE category IS NOT NULL
#         ORDER BY category
#     '''

#     cursor = db.get_db().cursor()
#     cursor.execute(query)
#     theData = cursor.fetchall()
        
#     response = make_response(jsonify(theData))
#     response.status_code = 200
#     return response

# # ------------------------------------------------------------
# # This is a stubbed route to update a product in the catalog
# # The SQL query would be an UPDATE. 
# @students.route('/product', methods = ['PUT'])
# def update_product():
#     product_info = request.json
#     current_app.logger.info(product_info)

#     return "Success"