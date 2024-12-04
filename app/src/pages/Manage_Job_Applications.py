import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

# Intro section for the application status page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_student_card"):
    ui.element("h2", children=["Manage Job Applications"], className="text-2xl font-bold text-gray-800", key="manage_jobs_title")
    ui.element("div", children=["\n\n"], key="manage_jobs_divider")
    ui.element("p", children=["View applications for positions at your company and click update to change the status."], className="text-gray-600")

# Retrieves information on each application for positions at the recruiter's company
# Hard coded to Microsoft for Damian 
data = {} 
try:
    data = requests.get('http://api:4000/a/applications/company/1').json()
    ui.element("h3", children=["Applications"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = [] 

# Information to display for each application
def AppProfileCard(application):
    with ui.element("div", key=f"app_card_{application['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
         ui.element("p", children=[f"Student Name: {application['student_name']}"], className="font-bold text-gray-600", key=f"app_title_{application['id']}")
         ui.element("p", children=[f"Job Title: {application['job_title']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
         ui.element("p", children=[f"Company: {application['company_name']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
         ui.element("p", children=[f"Applied At: {application['applied_at']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
         ui.element("p", children=[f"Status: {application['status']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
    #If clicked, bring user to update application status page
    updateBtn = ui.button("Update", className="bg-purple-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_student_{application['id']}")
    if updateBtn:
        st.session_state['updating_application_id'] = application['id']
        st.switch_page('pages/Update_Application_Status.py')

#If there are applications for that company in the database, display their information
if data and isinstance(data, list):
    if data:
        for application in data:
            AppProfileCard(application)
    else:
        ui.element("h3", children=["No applications found."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No applications found."], className="text-xl font-bold text-gray-800")

