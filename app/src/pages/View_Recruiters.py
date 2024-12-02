import logging
logger = logging.getLogger(__name__)
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_recruiters_card"):
    ui.element("h2", children=["View Recruiters"], className="text-2xl font-bold text-gray-800", key="view_recruiters_title")
    ui.element("div", children=["\n\n"], key="view_recruiters_divider")
    ui.element("p", children=["Here you can view all the jobs posted on our platform. You can see the job title, description, location, desired skills, targeted majors, number of applicants, whether the job is still accepting applications, and the date the job was posted and updated."], className="text-gray-600")

data = {} 
try:
    data = requests.get('http://api:4000/j/hiring-manager').json()
    ui.element("h3", children=["Recruiters"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  

def RecruiterCard(recruiter):
    with ui.element("div", key=f"recruiter_card_{recruiter['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element("h3", children=[f"{recruiter['name']} @ {recruiter['company_name']}"], className="text-xl font-bold text-gray-800", key=f"recruiter_name_{recruiter['id']}")
        ui.element("p", children=[f"Position: {recruiter['position']}"], className="text-gray-600", key=f"job_desc_{recruiter['id']}")
        ui.element("p", children=[f"Email: {recruiter['email']}"], className="text-gray-600", key=f"job_location_{recruiter['id']}")

