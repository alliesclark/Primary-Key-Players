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
    ui.element("p", children=["Look at all the co-ops you've applied to and delete the ones you wish to no longer be applying for."], className="text-gray-600")

data = {} 
try:
    data = requests.get('http://api:4000/a/applications').json()
except:
    logger.error("Error retrieving data from the API")
    data = []  
    
def deleteApplication(application):
    try:
        response = requests.delete(f'http://api:4000/a/applications/{application["id"]}')
        if response.status_code == 200:
            logger.info(f"Application deleted {application['id']}")    
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to delete application: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"delete_application_error_{application['id']}"
            )
    except:
        logger.error("Error deleting application")
        ui.element(
            "p",
            children=[
                f"Failed to delete application: Unknown error"
            ],
            className="text-red-500",
            key=f"delete_application_error_{application['id']}"
        )
    

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
    
    # doing 8 columns makes the layout a lot nicer
    col1, col2, col3, col4, col5, col6, col7, col8 = st.columns(8)
    with col1:
        deleteBtn = ui.button("Delete", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"delete_application_{application['id']}")
        if deleteBtn:
            deleteApplication(application)
    ui.alert_dialog(show=deleteBtn, title="Deleted Application", description=f"Your application for the role of {application['job_title']} at {application['company_name']} has been deleted.", confirm_label="OK", cancel_label="Cancel", key=f"alert_dialog_{application['id']}")


if data and isinstance(data, list):
    if data:
        for application in data:
            ApplicationCard(application)
    else:
        ui.element("h3", children=["No applications sent out."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No applications sent out."], className="text-xl font-bold text-gray-800")
