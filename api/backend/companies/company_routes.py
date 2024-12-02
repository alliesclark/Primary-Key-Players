from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db



#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
company = Blueprint('company', __name__)

#------------------------------------------------------------
# Get all the companies
@company.route('/company', methods=['GET'])
def get_all_companies():
    
    query = f'''SELECT c.id, 
                    c.name, 
                    c.description,
                    c.industry,
                    c.location,
                    c.criteria
                FROM company c
    '''
    
    # logging the query for debugging purposes.
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
    # It is only for debugging purposes.
    current_app.logger.info(f'GET /company query={query}')

    # get the database connection, execute the query, and
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
    
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect.
    current_app.logger.info(f'GET /company Result of query = {theData}')
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ------------------------------------------------------------
# Get the company information about a specific job
# notice that the route takes <id> and then you see id
# as a parameter to the function.  This is one way to send
# parameterized information into the route handler.
@company.route('/company/<id>', methods=['GET'])
def get_company_by_job (id):
    
        query = f'''SELECT c.id, 
                        c.name, 
                        c.description
                    FROM company c
                    WHERE c.id = {str(id)}
        '''
        
        # logging the query for debugging purposes.
        # The output will appear in the Docker logs output
        # This line has nothing to do with actually executing the query...
        # It is only for debugging purposes.
        current_app.logger.info(f'GET /company/<id> query={query}')
    
        # get the database connection, execute the query, and
        # fetch the results as a Python Dictionary
        cursor = db.get_db().cursor()
        cursor.execute(query)
        theData = cursor.fetchall()
        
        # Another example of logging for debugging purposes.
        # You can see if the data you're getting back is what you expect.
        current_app.logger.info(f'GET /company/<id> Result of query = {theData}')
        
        response = make_response(jsonify(theData))
        response.status_code = 200
        return response