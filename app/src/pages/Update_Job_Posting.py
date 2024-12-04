import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="edit_job_card"):
    ui.element("h2", children=["Manage Job Posting"], className="text-2xl font-bold text-gray-800", key="edit_job_title")
    ui.element("div", children=["\n\n"], key="edit_job_postings_divider")
    ui.element("p", children=["Edit job information."], className="text-gray-600")

data = {} 
try:
    data = requests.get("http://api:4000/j/job-positions/" + str(st.session_state['updating_job_id'])).json()
    logger.info(f"Retrieved job posting data: {data}")
    ui.element("h3", children=["Job"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    

def updateJob(job_id, updated_data):
    try:
        response = requests.put(
            f'http://api:4000/j/job-position/{job_id}', 
            json=updated_data
        )
        
        if response.status_code == 200:
            logger.info(f"Job posting updated successfully: {job_id}")
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to update job posting: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"update_job_error_{job_id}"
            )
    except Exception as e:
        logger.error(f"Error updating job posting: {str(e)}")
        ui.element(
            "p",
            children=[
                "Failed to update job posting: Unknown error"
            ],
            className="text-red-500",
            key=f"update_job_error_{job_id}"
        )

def UpdateJobCard(job):
    updated_title = st.text_input(label="Title:", value=job['title'])
    updated_description = st.text_area(label="Email:", value=student['email'])
    updated_location = st.text_input(label="Email:", value=student['email'])
    updated_desired_skills = st.number_input(label="Graduation Year:", value=student['grad_year'], step=1)
    updated_targeted_majors = st.text_input(label="GPA:", value=student['gpa'])
    updated_num_applicants = st.text_input(label="GPA:", value=student['gpa'])
    data_still_accepting = st.text_input(label="GPA:", value=student['gpa'])
    
    majors = []
    try:
        majors = requests.get('http://api:4000/m/majors').json()
    except Exception as e:
        logger.error(f"Error retrieving company data: {e}")
        majors = []

    

    saveBtn = ui.button("Save", className="bg-blue-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"save_student_{student['student_id']}")
    
    if saveBtn:
        updated_data = {
            "name": updated_name,
            "email": updated_email,
            "gpa": updated_gpa,
            "major_id": updated_major_id,
            "grad_year": updated_grad_year,
            "advised_by": updated_advisor_id,
        }
        try:
            updateStudent(student['student_id'], updated_data)
            st.success("Profile updated successfully!")
            st.switch_page('pages/Student_Profiles.py')
        except Exception as e:
            st.error(f"Error updating profile: {str(e)}")

if data:
    UpdateProfileCard(data[0])
    