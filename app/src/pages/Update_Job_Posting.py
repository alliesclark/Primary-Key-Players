import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

#Intro section for update job posting page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="edit_job_card"):
    ui.element("h2", children=["Manage Job Posting"], className="text-2xl font-bold text-gray-800", key="edit_job_title")
    ui.element("div", children=["\n\n"], key="edit_job_postings_divider")
    ui.element("p", children=["Edit job information."], className="text-gray-600")

#Retrieve information for the specific job posting
data = {} 
try:
    data = requests.get("http://api:4000/j/job-position/" + str(st.session_state['updating_job_id'])).json()
    logger.info(f"Retrieved job posting data: {data}")
    ui.element("h3", children=["Job"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    
#Update job posting information in the database
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

#Display job posting informatioon as editable fields
def UpdateJobCard(job):
    updated_title = st.text_input(label="Title:", value=job['title'])
    updated_description = st.text_area(label="Description:", value=job['description'], max_chars=500)
    updated_location = st.text_input(label="Location:", value=job['location'])
    updated_desired_skills = st.text_input(label="Desired Skills:", value=job['desired_skills'])
    updated_targeted_majors = st.text_input(label="Targeted Majors:", value=job['targeted_majors'])
    updated_num_applicants = st.text_input(label="Number of Applicants:", value=job['num_applicants'])
    if job['still_accepting'] == 1:
        data_still_accepting = st.text_input(label="Still Accepting:", value='Yes')
    if job['still_accepting'] == 0:
        data_still_accepting = st.text_input(label="Still Accepting:", value='No')
    if data_still_accepting == 'Yes' or data_still_accepting == 'yes':
        updated_still_accepting = 1
    else:
        updated_still_accepting = 0

    saveBtn = ui.button("Save", className="bg-blue-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"save_job_{job['id']}")
    #If click save button, update job posting to edited information
    if saveBtn:
        updated_data = {
            "title": updated_title,
            "description": updated_description,
            "location": updated_location,
            "desired_skills": updated_desired_skills,
            "targeted_majors": updated_targeted_majors,
            "num_applicants": updated_num_applicants,
            "still_accepting": updated_still_accepting
        }
        try:
            updateJob(job['id'], updated_data)
            st.success("Job posting updated successfully!")
            st.switch_page('pages/Manage_Job_Postings.py')
        except Exception as e:
            st.error(f"Error updating profile: {str(e)}")

#Display the job postings information
if data:
    UpdateJobCard(data[0])
    