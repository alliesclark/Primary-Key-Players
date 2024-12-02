import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_jobs_card"):
    ui.element("h2", children=["View Jobs"], className="text-2xl font-bold text-gray-800", key="view_jobs_title")
    ui.element("div", children=["\n\n"], key="view_jobs_divider")
    ui.element("p", children=["Here you can view all the jobs posted on our platform. You can see the job title, description, location, desired skills, targeted majors, number of applicants, whether the job is still accepting applications, and the date the job was posted and updated."], className="text-gray-600")

# Get all students
students = {}
try:
    students = requests.get('http://api:4000/s/students').json()
    ui.element("h3", children=["Students"], className="text-xl font-bold text-gray-800")
except:
    logger.error("Error retrieving data from the API")
    students = []

student_options = {student['name']: student["id"] for student in students}
desired_student = ui.select(options=list(student_options.keys()), label="Select student:")
desired_student_id = student_options.get(desired_student)

# Get all jobs
data = {} 
try:
    data = requests.get('http://api:4000/j/job-position').json()
    ui.element("h3", children=["Jobs"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  
    
    
def submit_application(job):
    application = {
        "applicant_id": desired_student_id, 
        "job_position_id": job["id"],
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

        # Button Section: Flex alignment
        with ui.element("div", className="flex justify-end mt-4"):
            # Already Applied or Apply Button
            already_applied = False
            try:
                applications = requests.get(f'http://api:4000/a/applications/{desired_student_id}').json()
                already_applied = any(application["job_position_id"] == job["id"] for application in applications)
            except requests.exceptions.RequestException as e:
                logger.error(f"Failed to get applications for student {desired_student_id}: {str(e)}")

            if already_applied:
                ui.element(
                    "p",
                    children=["You have already applied for this job"],
                    className="text-gray-800 font-bold text-sm",
                    key=f"already_applied_{job['id']}"
                )
            else:
                # Apply Button
                applied = ui.button(
                    "Apply",
                    className="bg-blue-500 text-white px-4 py-2 rounded-md",
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
