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