import streamlit_shadcn_ui as ui
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import streamlit_shadcn_ui as ui

st.set_page_config(layout = 'wide', page_title='Co-op Connect')

SideBarLinks(show_home=True)

