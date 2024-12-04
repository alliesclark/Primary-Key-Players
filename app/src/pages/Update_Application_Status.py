import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

#Intro section for update application status page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="edit_status_card"):
    ui.element("h2", children=["Manage Job Application Status"], className="text-2xl font-bold text-gray-800", key="edit_status_title")
    ui.element("div", children=["\n\n"], key="edit_status_divider")
    ui.element("p", children=["Edit application status below."], className="text-gray-600")

#Retrieve application information for the selected application id
data = {} 
try:
    data = requests.get("http://api:4000/a/applications/" + str(st.session_state['updating_application_id'])).json()
    logger.info(f"Retrieved application data: {data}")
    ui.element("h3", children=["Application"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    
#Updates application status in the database
def updateStatus(application_id, updated_data):
    try:
        response = requests.put(
            f'http://api:4000/a/applications/{application_id}', 
            json=updated_data
        )
        
        if response.status_code == 200:
            logger.info(f"Application status updated successfully: {application_id}")
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to update application status: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"update_statis_error_{application_id}"
            )
    except Exception as e:
        logger.error(f"Error updating application status: {str(e)}")
        ui.element(
            "p",
            children=[
                "Failed to update application status: Unknown error"
            ],
            className="text-red-500",
            key=f"update_status_error_{application_id}"
        )

#Displays application information and allows user to update status
def UpdateAppStatusCard(application):
    with ui.element("div", key=f"app_card_{application['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
         ui.element("p", children=[f"Student Name: {application['student_name']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
         ui.element("p", children=[f"Job Title: {application['job_title']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
         ui.element("p", children=[f"Company: {application['company_name']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
         ui.element("p", children=[f"Applied At: {application['applied_at']}"], className="text-gray-600", key=f"app_desc_{application['id']}")
    status_options = ['Accepted', 'Pending', 'Rejected']
    
    # Sort status options to put previous status at the top
    if application['status'] == 'Accepted':
        status_options = ['Accepted', 'Pending', 'Rejected']
    if application['status'] == 'Pending':
        status_options = ['Pending', 'Accepted', 'Rejected']
    if application['status'] == 'Rejected':
        status_options = ['Rejected', 'Accepted', 'Pending']
    
    st.write("Select application status:\n")
    updated_status = ui.select(options=status_options, label="Select status:", key="status_select")
 
    saveBtn = ui.button("Save", className="bg-blue-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"save_status_{application['id']}")
    #Updates status if save button is clicked and then redirects back to previous page
    if saveBtn:
        updated_data = {
            "id": application['id'],
            "applicant_id": application['applicant_id'],
            "job_position_id": application['job_position_id'],
            "status": updated_status
        }
        try:
            updateStatus(application['id'], updated_data)
            st.success("Application status updated successfully!")
            st.switch_page('pages/Manage_Job_Applications.py')
        except Exception as e:
            st.error(f"Error updating application status: {str(e)}")

#Displays application information
if data:
    UpdateAppStatusCard(data[0])
    