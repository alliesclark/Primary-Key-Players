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
    ui.element("h2", children=["Welcome Wade!"], className="text-2xl font-bold text-gray-800", key="maura_welcome")
    ui.element("div", children=["\n\n"], key="maura_divider")
    ui.element("p", children=["As a student with previous co-op experience, this page will be your hub for key resources most useful to you."], className="text-gray-600")

with ui.element("div", className="flex flex-row justify-center items-center", key="wade_buttons"):
    with ui.element("div", className="flex flex-col m-2", key="wade_button_1"):
        if ui.button(text="Post Reviews", key="1", className="bg-green-700 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/Post_Review.py')
    with ui.element("div", className="flex flex-col m-2", key="wade_button_2"):
        if ui.button(text="Manage Past Reviews", key="2", className="bg-green-700 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/Manage_Reviews.py')
    with ui.element("div", className="flex flex-col m-2", key="wade_button_3"):
        if ui.button(text="Post Interview Questions", key="3", className="bg-green-700 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/Post_Interview_Question.py')
    with ui.element("div", className="flex flex-col m-2", key="wade_button_4"):
        if ui.button(text="View Reviews", key="4", className="bg-green-700 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/See_Reviews.py')
    with ui.element("div", className="flex flex-col m-2", key="wade_button_5"):
        if ui.button(text="View Job Positions", key="5", className="bg-green-700 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/View_Jobs.py')
    # with ui.element("div", className="flex flex-col m-2", key="wade_button_6"):
    #     if ui.button(text="Questions From Peers", key="6", className="bg-green-700 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
    #         st.switch_page('pages/View_Jobs.py')
 