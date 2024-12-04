import streamlit_shadcn_ui as ui
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import streamlit_shadcn_ui as ui

st.set_page_config(layout = 'wide', page_title='Co-op Connect')

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_jobs_card"):
    ui.element("h2", children=["Welcome Damian!"], className="text-2xl font-bold text-gray-800", key="damian_welcome")
    ui.element("div", children=["\n\n"], key="damian_divider")
    ui.element("p", children=["As a recruiter, this page will be your hub for key resources most useful to you."], className="text-gray-600")
    
with ui.element("div", className="flex flex-row justify-center items-center", key="winston_buttons"):
    with ui.element("div", className="flex flex-col m-2", key="damian_button_1"):
        if ui.button(text="Manage Job Postings", key="1", className="bg-orange-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/Manage_Job_Postings.py')
    with ui.element("div", className="flex flex-col m-2", key="damian_button_2"):
        if ui.button(text="Search Students", key="2", className="bg-orange-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/Search_Students.py')
    with ui.element("div", className="flex flex-col m-2", key="damian_button_3"):
        if ui.button(text="See Job Postings", key="3", className="bg-orange-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/View_Jobs.py')
    with ui.element("div", className="flex flex-col m-2", key="damian_button_4"):
        if ui.button(text="See Job Reviews", key="4", className="bg-orange-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/See_Reviews.py')
    with ui.element("div", className="flex flex-col m-2", key="damian_button_5"):
        if ui.button(text="Update Application Statuses", key="5", className="bg-orange-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/Application_Status.py')
  

