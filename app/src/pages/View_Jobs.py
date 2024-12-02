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

data = {} 
try:
    data = requests.get('http://api:4000/j/job-position').json()
    ui.element("h3", children=["Jobs"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  

def JobCard(job):
    with ui.element("div", key=f"job_card_{job['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element("h3", children=[job["title"]], className="text-xl font-bold text-gray-800", key=f"job_title_{job['id']}")
        ui.element("p", children=[f"Description: {job['description']}"], className="text-gray-600", key=f"job_desc_{job['id']}")
        ui.element("p", children=[f"Location: {job['location']}"], className="text-gray-600", key=f"job_location_{job['id']}")
        ui.element("p", children=[f"Desired Skills: {job['desired_skills']}"], className="text-gray-600", key=f"job_skills_{job['id']}")
        ui.element("p", children=[f"Targeted Majors: {job['targeted_majors']}"], className="text-gray-600", key=f"job_majors_{job['id']}")
        ui.element("p", children=[f"Number of Applicants: {job['num_applicants']}"], className="text-gray-600", key=f"job_applicants_{job['id']}")
        ui.element(
            "span",
            children=["Still Accepting: Yes" if job["still_accepting"] else "Still Accepting: No"],
            className="text-green-500" if job["still_accepting"] else "text-red-500",
            key=f"job_accepting_{job['id']}",
        )
        ui.element("p", children=[f"Posted At: {job['postedAt']}"], className="text-gray-400 text-sm", key=f"job_posted_{job['id']}")
        ui.element("p", children=[f"Updated At: {job['updatedAt']}"], className="text-gray-400 text-sm", key=f"job_updated_{job['id']}")

# Render only jobs that are still accepting applications
if data and isinstance(data, list):
    accepting_jobs = [job for job in data if job.get("still_accepting")]
    if accepting_jobs:
        for job in accepting_jobs:
            JobCard(job)
    else:
        ui.element("h3", children=["No jobs currently accepting applications"], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No jobs found"], className="text-xl font-bold text-gray-800")
