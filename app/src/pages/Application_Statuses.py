import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_jobs_card"):
    ui.element("h2", children=["View Your Applications"], className="text-2xl font-bold text-gray-800", key="view_apps_title")
    ui.element("div", children=["\n\n"], key="view_jobs_divider")
    ui.element("p", children=["Look at all the co-ops you've applied to."], className="text-gray-600")

data = {} 
try:
    data = requests.get('http://api:4000/a/applications').json()
except:
    logger.error("Error retrieving data from the API")
    data = []  

def ApplicationCard(application):
    with ui.element("div", key=f"application_card_{application['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element(
            "h3",
            children=[f"Status: {application['status']}"],
            className="text-xl font-bold text-gray-800",
            key=f"application_status_{application['id']}"
        )

        if 'job_title' in application:
            ui.element(
                "p",
                children=[f"Job: {application['job_title']} @ {application['company_name']}"],
                className="text-gray-600",
                key=f"application_job_title_{application['id']}"
            )

        ui.element(
            "p",
            children=[f"Applied At: {application['applied_at']}"],
            className="text-gray-400 text-sm",
            key=f"application_applied_at_{application['id']}"
        )


if data and isinstance(data, list):
    if data:
        for application in data:
            ApplicationCard(application)
    else:
        ui.element("h3", children=["No applications sent out."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No applications sent out."], className="text-xl font-bold text-gray-800")
