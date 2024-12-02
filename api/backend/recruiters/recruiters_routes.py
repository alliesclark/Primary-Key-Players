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
recruiters = Blueprint('recruiters', __name__)

#------------------------------------------------------------
# Get all the recruiters from the database, package them up,
# and return them to the client
@recruiters.route('/recruiters', methods=['GET'])
def get_recruiters():
    query = '''
        SELECT  id,
                name,
                position,
                email,
                company_id
                c.name as company_name 
        FROM hiring_manager h
        JOIN company c ON h.company_id = c.id
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of recruiters
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
# Get recruiter information about a specific recruiter
@recruiters.route('/recruiters/<id>', methods=['GET'])
def get_recruiters_detail (id):

    query = f'''SELECT id, 
                       name,
                       position,
                       email,
                       company_id
                FROM hiring_manager 
                WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /recruiters/<id> query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /recruiters/<id> Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Get contact information about a specific recruiter
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
@recruiters.route('/recruiters/{id}/contact-info', methods=['GET'])
def get_recruiters_contact (id):

    query = f'''SELECT id,
                       name, 
                       email, 
                FROM hiring_manager
                WHERE id = {str(id)}
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /recruiters/<id>/contact-info query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /recruiters/<id>/contact-info Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response
