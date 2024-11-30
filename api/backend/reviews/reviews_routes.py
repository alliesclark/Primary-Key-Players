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
students = Blueprint('reviews', __name__)

#------------------------------------------------------------
# Get all the reviews from the database
@students.route('/reviews', methods=['GET'])
def get_review():
    query = '''
        SELECT  id, 
                rating, 
                review, 
                student_id, 
                job_position_id
        FROM reviews
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
# Add a new review to the database
@students.route('/reviews', methods=['POST'])
def add_review():
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
        INSERT INTO reviews (id, rating, review, student_id, job_position_id)
        VALUES ('{id}', '{rating}', {review}, {student_id}, {job_position_id})
    '''
    current_app.logger.info(query)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully added review")
    response.status_code = 200



# ------------------------------------------------------------
# Get information about a specific review
@students.route('/reviews/<id>', methods=['GET'])
def get_review_detail (id):

    query = '''
        SELECT  id, 
                rating, 
                review, 
                student_id, 
                job_position_id
        FROM reviews
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
# Get contact information about a specific student
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
@students.route('/student/{id}/contact-info', methods=['GET'])
def get_student_contact (id):

    query = f'''SELECT id,
                       name, 
                       email, 
                FROM students 
                WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /student/<id>/contact-info query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /student/<id>/contact-info Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Retrieve a list of students who previously had the specified job position
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
# Get all the products from the database, package them up,
# and return them to the client
@students.route('/products', methods=['GET'])
def get_products():
    query = '''
        SELECT  id, 
                product_code, 
                product_name, 
                list_price, 
                category 
        FROM products
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
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
# get product information about a specific product
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send 
# parameterized information into the route handler.
@students.route('/product/<id>', methods=['GET'])
def get_product_detail (id):

    query = f'''SELECT id, 
                       product_name, 
                       description, 
                       list_price, 
                       category 
                FROM products 
                WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.  
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes. 
    current_app.logger.info(f'GET /product/<id> query={query}')

    # get the database connection, execute the query, and 
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect. 
    current_app.logger.info(f'GET /product/<id> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response
    
# ------------------------------------------------------------
# Get the top 5 most expensive products from the database
@students.route('/mostExpensive')
def get_most_pop_products():

    query = '''
        SELECT product_code, 
               product_name, 
               list_price, 
               reorder_level
        FROM products
        ORDER BY list_price DESC
        LIMIT 5
    '''
    
    # Same process as handler above
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
 
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ------------------------------------------------------------
# Route to get the 10 most expensive items from the 
# database.
@students.route('/tenMostExpensive', methods=['GET'])
def get_10_most_expensive_products():
    
    query = '''
        SELECT product_code, 
               product_name, 
               list_price, 
               reorder_level
        FROM products
        ORDER BY list_price DESC
        LIMIT 10
    '''
    
    # Same process as above
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response
    

# ------------------------------------------------------------
# This is a POST route to add a new product.
# Remember, we are using POST routes to create new entries
# in the database. 
@students.route('/product', methods=['POST'])
def add_new_product():
    
    # In a POST request, there is a 
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    name = the_data['product_name']
    description = the_data['product_description']
    price = the_data['product_price']
    category = the_data['product_category']
    
    query = f'''
        INSERT INTO products (product_name,
                              description,
                              category, 
                              list_price)
        VALUES ('{name}', '{description}', '{category}', {str(price)})
    '''
    # TODO: Make sure the version of the query above works properly
    # Constructing the query
    # query = 'insert into products (product_name, description, category, list_price) values ("'
    # query += name + '", "'
    # query += description + '", "'
    # query += category + '", '
    # query += str(price) + ')'
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    response = make_response("Successfully added product")
    response.status_code = 200
    return response

# ------------------------------------------------------------
### Get all product categories
@students.route('/categories', methods = ['GET'])
def get_all_categories():
    query = '''
        SELECT DISTINCT category AS label, category as value
        FROM products
        WHERE category IS NOT NULL
        ORDER BY category
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
        
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ------------------------------------------------------------
# This is a stubbed route to update a product in the catalog
# The SQL query would be an UPDATE. 
@students.route('/product', methods = ['PUT'])
def update_product():
    product_info = request.json
    current_app.logger.info(product_info)

    return "Success"