from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db



#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
majors = Blueprint('majors', __name__)

#------------------------------------------------------------
# Get all the applications
@majors.route('/majors', methods=['GET'])
def get_all_majors():
    
    query = f'''SELECT id,
                       name,
                       department
                FROM major
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    applications = cursor.fetchall()
    
    
    response = make_response(jsonify(applications))
    response.status_code = 200
    return response