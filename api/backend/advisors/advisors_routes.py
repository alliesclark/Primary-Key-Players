from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db



#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
advisors = Blueprint('advisors', __name__)

#------------------------------------------------------------
# Get all the applications
@advisors.route('/advisors', methods=['GET'])
def get_coop_advisors():
    
    query = f'''SELECT id,
                       name,
                       email,
                       department_id
                FROM coop_advisor
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    applications = cursor.fetchall()
    
    
    response = make_response(jsonify(applications))
    response.status_code = 200
    return response