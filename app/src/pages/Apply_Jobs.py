import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_jobs_card"):
    ui.element("h2", children=["Apply to Co-ops"], className="text-2xl font-bold text-gray-800", key="view_jobs_title")
    ui.element("div", children=["\n\n"], key="view_jobs_divider")
    ui.element("p", children=["It is now time to finally apply to available job positions. You can easily submit an application by simply clicking the `Apply` button above the position."], className="text-gray-600")


# Get all jobs
data = {} 
try:
    data = requests.get('http://api:4000/j/job-position').json()
    ui.element("h3", children=["Jobs"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  
    
    
def submit_application(job):
    # Hardcoding the student id for now as Maura always has student 1 in the database
    application = {
        "applicant_id": 1, 
        "job_position_id": job['id'],
    }
    try:
        response = requests.post('http://api:4000/a/applications', json=application)

        if response.status_code == 201:
            ui.element(
                "p",
                children=["Application submitted successfully"],
                className="text-green-500",
                key=f"application_success_{job['id']}"
            )
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to submit application: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"application_failure_{job['id']}"
            )
    except requests.exceptions.RequestException as e:
        # Handle request errors
        ui.element(
            "p",
            children=[f"Failed to submit application due to an error: {str(e)}"],
            className="text-red-500",
            key=f"application_failure_{job['id']}"
        )
    logger.debug(f"Submission status: {response.status_code}")


def JobCard(job):
    with ui.element("div", key=f"job_card_{job['id']}", className="p-4 m-2 shadow-lg rounded-lg border h-fit"):
        # Job Details
        ui.element("h3", children=[f"{job['title']} @ {job['company_name']}"], className="text-xl font-bold text-gray-800", key=f"job_title_{job['id']}")
        ui.element("p", children=[f"Description: {job['description']}"], className="text-gray-600", key=f"job_desc_{job['id']}")
        ui.element("p", children=[f"Location: {job['location']}"], className="text-gray-600", key=f"job_location_{job['id']}")
        ui.element("p", children=[f"Desired Skills: {job['desired_skills']}"], className="text-gray-600", key=f"job_skills_{job['id']}")
        ui.element("p", children=[f"Targeted Majors: {job['targeted_majors']}"], className="text-gray-600", key=f"job_majors_{job['id']}")
        ui.element("p", children=[f"Number of Applicants: {job['num_applicants']}"], className="text-gray-600", key=f"job_applicants_{job['id']}")
        
        # Still Accepting Applications
        ui.element(
            "span",
            children=["Still Accepting: Yes" if job["still_accepting"] else "Still Accepting: No"],
            className="text-green-500" if job["still_accepting"] else "text-red-500",
            key=f"job_accepting_{job['id']}",
        )

        # Timestamps
        ui.element("p", children=[f"Posted At: {job['postedAt']}"], className="text-gray-400 text-sm", key=f"job_posted_{job['id']}")
        ui.element("p", children=[f"Updated At: {job['updatedAt']}"], className="text-gray-400 text-sm", key=f"job_updated_{job['id']}")
    
    col1, col2, col3, col4, col5, col6, col7, col8 = st.columns(8)
    already_applied = False
    try:
        applications = requests.get(f'http://api:4000/a/applications/student/{1}').json()
        already_applied = any(application["job_position_id"] == job["id"] for application in applications)
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to get applications for student {1}: {str(e)}")
        
    with col1:  
        applied = ui.button(
            text="Applied" if already_applied else "Apply",
            className="bg-gray-400 text-white px-4 py-2 rounded-md w-fit" if already_applied else  "bg-blue-500 text-white px-4 py-2 rounded-md",
            variant="disabled" if already_applied else "default",
            key=f"apply_button_{job['id']}"
        )
        if applied:
            submit_application(job)

                

# Render Job Cards
if data and isinstance(data, list):
    accepting_jobs = [job for job in data if job.get("still_accepting")]
    if accepting_jobs:
        for job in accepting_jobs:
            JobCard(job)
    else:
        ui.element("h3", children=["No jobs currently accepting applications"], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No jobs found"], className="text-xl font-bold text-gray-800")
