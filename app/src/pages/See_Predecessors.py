import logging
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

# Setup logger
logger = logging.getLogger(__name__)

# Display navigation links
SideBarLinks(show_home=True)

# Intro section
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_jobs_card"):
    ui.element("h2", children=["See predecessors for the co-op you want"], className="text-2xl font-bold text-gray-800", key="view_jobs_title")
    ui.element("div", children=["\n\n"], key="view_jobs_divider")
    ui.element("p", children=["Reach out to students who have worked the role you desire, email them and set up a coffee chat!"], className="text-gray-600")

# Fetch job data
jobs = []
try:
    jobs = requests.get('http://api:4000/j/job-position').json()
except Exception as e:
    logger.error(f"Error retrieving job data: {e}")
    st.write("Failed to load job data. Using fallback options.")
    jobs = []

# Create a dropdown to select a job
job_options = {job['title']: job["id"] for job in jobs}
desired_job_title = ui.select(options=list(job_options.keys()), label="Select a position:")
desired_job_id = job_options.get(desired_job_title)

# Fetch students associated with the selected job
students_data = []
if desired_job_id:
    try:
        students_data = requests.get(f'http://api:4000/s/students/job-position/{desired_job_id}').json()
        logger.info(f"Retrieved students data for job ID: {desired_job_id}")
    except Exception as e:
        logger.error(f"Error retrieving students data: {e}")
        students_data = []

# Render student cards
def StudentCard(student):
    with ui.element("div", key=f"student_card_{student['email']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element("h3", children=[student["name"]], className="text-xl font-bold text-gray-800", key=f"student_name_{student['email']}")
        ui.element("p", children=[f"Email: {student['email']}"], className="text-gray-600", key=f"student_email_{student['email']}")
        ui.element("p", children=[f"Major: {student['major']}"], className="text-gray-600", key=f"student_major_{student['email']}")
        ui.element("p", children=[f"Graduation Year: {student['grad_year']}"], className="text-gray-600", key=f"student_grad_year_{student['email']}")

# Display student cards or a fallback message
if students_data and isinstance(students_data, list):
    if students_data:
        for student in students_data:
            StudentCard(student)
    else:
        ui.element("h3", children=["No students available for this position"], className="text-xl font-bold text-gray-800")
else:
    logger.error("Failed to load student data or invalid job selected")
    ui.element("h3", children=["Failed to load student data or invalid job selected"], className="text-xl font-bold text-gray-800")
