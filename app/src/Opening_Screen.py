##################################################
# This is the main/entry-point file for the 
# sample application for your project
##################################################
import streamlit_shadcn_ui as ui
# Set up basic logging infrastructure
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# import the main streamlit library as well
# as SideBarLinks function from src/modules folder
import streamlit as st
from modules.nav import SideBarLinks

# streamlit supports reguarl and wide layout (how the controls
# are organized/displayed on the screen).
st.set_page_config(layout = 'wide', page_title='Co-op Connect')


# If a user is at this page, we assume they are not 
# authenticated.  So we change the 'authenticated' value
# in the streamlit session_state to false. 
st.session_state['authenticated'] = False

# Use the SideBarLinks function from src/modules/nav.py to control
# the links displayed on the left-side panel. 
# IMPORTANT: ensure src/.streamlit/config.toml sets
# showSidebarNavigation = false in the [client] section
SideBarLinks(show_home=True)

# ***************************************************
#    The major content of this page
# ***************************************************
with ui.element("div", className="bg-transparent p-3 flex justify-center items-center flex-col", key="parent-container"):
    with ui.element("div", className="bg-transparent p-3 flex justify-center flex-row", key="container"):
        # ui.element("img", src="assets/husky.png", key="logo")
        with ui.element("div", className="bg-transparent p-4", key="opening_screen"):
            ui.element("span", children=["Co-op"], className="text-4xl font-bold", key="title1")
            ui.element("div", children=["\n"], key="space1")
            ui.element("span", children=["Connect"], className="text-4xl text-red-500 font-bold", key="title2")
            ui.element("div", children=["\n"], key="space2")
    

    


if ui.button(text="proceed", key="continue_btn", className="bg-red-300 text-white font-bold py-2 px-4 shadow rounded-lg w-full"):
            st.switch_page('pages/User_Selection_Page.py')

