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
    ui.element("p", children=["Enter an application ID to update its status."], className="text-gray-600")

#Take in application id
application_id = st.text_input(label="Application ID:")

#Bring user to update application status page (for the input application id)
submitBtn = ui.button("Submit", className="bg-blue-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_ap")
if submitBtn:
    st.session_state['updating_application_id'] = application_id
    st.switch_page('pages/Update_Application_Status.py')

