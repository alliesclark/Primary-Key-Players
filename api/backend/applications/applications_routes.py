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
# Get specific application
@job_applications.route('/applications/<application_id>', methods=['GET'])
def get_applications_by_application_id(application_id):
    
    query = f'''SELECT a.id AS id, 
                    a.applicant_id AS applicant_id, 
                    a.job_position_id AS job_position_id,
                    a.status AS status,
                    a.applied_at AS applied_at,
                    s.name AS student_name,
                    j.title AS job_title,
                    c.name AS company_name
                FROM application a
                JOIN student s ON a.applicant_id = s.id
                JOIN job_position j ON a.job_position_id = j.id
                JOIN company c ON j.company_id = c.id
                WHERE a.id = {str(application_id)}
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
                    j.title as job_title,
                    c.name as company_name
                FROM application a
                JOIN student s ON a.applicant_id = s.id
                JOIN job_position j ON a.job_position_id = j.id
                JOIN company c ON j.company_id = c.id
                WHERE a.applicant_id = {student_id}
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    applications = cursor.fetchall()
    
    
    response = make_response(jsonify(applications))
    response.status_code = 200
    return response

#------------------------------------------------------------
# Get all the applications for a specific company
@job_applications.route('/applications/company/<company_id>', methods=['GET'])
def get_job_applications_by_company(company_id):
    
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
                WHERE c.id = {str(company_id)}
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    applications = cursor.fetchall()
    
    
    response = make_response(jsonify(applications))
    response.status_code = 200
    return response

#------------------------------------------------------------
# Create a new application
@job_applications.route('/applications', methods=['POST'])
def create_application():
    
    data = request.get_json()
    applicant_id = data['applicant_id']
    job_position_id = data['job_position_id']
    
    query = f'''INSERT INTO application (applicant_id, job_position_id)
                VALUES ({applicant_id}, {job_position_id})
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    response = make_response(jsonify({'message': 'Application created'}))
    response.status_code = 201
    return response


#------------------------------------------------------------
# Update a job application
@job_applications.route('/applications/<application_id>', methods=['PUT'])
def update_job_application(application_id):
    # Collecting data from the request object
    data = request.json
    current_app.logger.info(data)

    # Extracting the variables
    applicant_id = data['applicant_id']
    job_position_id = data['job_position_id']
    status = data['status']

    # Constructing the query
    query = f'''
        UPDATE job_position
        SET applicant_id = '{applicant_id}', job_position_id = '{job_position_id}', status = '{status}'
        WHERE id = {application_id}
    '''
    current_app.logger.info(query)

    # Executing and committing the update statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully updated job application")
    response.status_code = 200
    return response

#------------------------------------------------------------
# Delete an application
@job_applications.route('/applications/<application_id>', methods=['DELETE'])
def delete_application(application_id):
    
    query = f'''DELETE FROM application WHERE id = {application_id}
    '''
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    response = make_response(jsonify({'message': 'Application deleted'}))
    response.status_code = 200
    return response
      