from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db



#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
job_applications = Blueprint('applications', __name__)

#------------------------------------------------------------
# Get all the applications
@job_applications.route('/applications', methods=['GET'])
def get_job_applications():
    
    query = f'''SELECT a.id, 
                    a.applicant_id, 
                    a.job_position_id,
                    a.status,
                    a.applied_at,
                    s.name as student_name,
                    j.title as job_title,
                    c.name as company_name
                FROM application a
                JOIN student s ON a.applicant_id = s.id
                JOIN job_position j ON a.job_position_id = j.id
                JOIN company c ON j.company_id = c.id
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    applications = cursor.fetchall()
    
    
    response = make_response(jsonify(applications))
    response.status_code = 200
    return response

      

#------------------------------------------------------------
# Get all the applications for a specific student
@job_applications.route('/applications/<student_id>', methods=['GET'])
def get_job_applications_by_student(student_id):
    
    query = f'''SELECT a.id, 
                    a.applicant_id, 
                    a.job_position_id,
                    a.status,
                    a.applied_at,
                    s.name as student_name,
                    j.title as job_title
                FROM application a
                JOIN student s ON a.applicant_id = s.id
                JOIN job_position j ON a.job_position_id = j.id
                WHERE a.applicant_id = {student_id}
    '''
    
    cursor = db.cursor()
    cursor.execute(query)
    applications = cursor.fetchall()
    
    
    response = make_response(jsonify(applications))
    response.status_code = 200
    return response

      