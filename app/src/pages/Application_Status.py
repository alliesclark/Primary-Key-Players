import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_student_card"):
    ui.element("h2", children=["Manage Job Applications"], className="text-2xl font-bold text-gray-800", key="manage_jobs_title")
    ui.element("div", children=["\n\n"], key="manage_jobs_divider")
    ui.element("p", children=["Enter an application ID to update its status."], className="text-gray-600")

application_id = st.text_input(label="Application ID:")

submitBtn = ui.button("Submit", className="bg-blue-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_ap")
if submitBtn:
    st.switch_page('pages/Add_Job.py')

