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
    ui.element("h2", children=["Welcome Winston!"], className="text-2xl font-bold text-gray-800", key="damian_welcome")
    ui.element("div", children=["\n\n"], key="damian_divider")
    ui.element("p", children=["As a co-op advisor, this page will be your hub for key resources most useful to you."], className="text-gray-600")
    
with ui.element("div", className="flex flex-row justify-center items-center", key="winston_buttons"):
    with ui.element("div", className="flex flex-col m-2", key="winston_button_1"):
        if ui.button(text="View Recruiters", key="1", className="bg-blue-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/View_Recruiters.py')
    with ui.element("div", className="flex flex-col m-2", key="winston_button_2"):
        if ui.button(text="View Job Positions", key="2", className="bg-blue-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/View_Jobs.py')
    with ui.element("div", className="flex flex-col m-2", key="winston_button_3"):
        if ui.button(text="View Reviews", key="3", className="bg-blue-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/See_Reviews.py')
    with ui.element("div", className="flex flex-col m-2", key="winston_button_4"):
        if ui.button(text="Manage Student Profiles", key="4", className="bg-blue-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/Student_Profiles.py')

