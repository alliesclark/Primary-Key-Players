#################################
# Interview Questions Blueprint #
#################################

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db



#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
interview_questions = Blueprint('interview_questions', __name__)

#------------------------------------------------------------
# Get all the students from the database, package them up,
# and return them to the client
@interview_questions.route('/interview_questions', methods=['GET'])
def get_students():
    query = '''
        SELECT  id, 
                question, 
                job_position_id, 
                author_id
        FROM interview_question
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

# Post a new job position to the database
@interview_questions.route('/interview_questions', methods=['POST'])
def post_interview_question():
    # Collecting data from the request object
    question_data = request.json
    current_app.logger.info(question_data)

    # Extracting the variables
    question = question_data['question']
    job_position_id = question_data['job_position_id']
    author_id = question_data['author_id']

    query = f'''
        INSERT INTO interview_question (question, job_position_id, author_id)
        VALUES ('{question}', '{job_position_id}', '{author_id}')
    '''
    current_app.logger.info(query)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    response = make_response("Successfully added question")
    response.status_code = 200
    return response


