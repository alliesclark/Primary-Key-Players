import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_student_card"):
    ui.element("h2", children=["Manage Job Postings"], className="text-2xl font-bold text-gray-800", key="manage_jobs_title")
    ui.element("div", children=["\n\n"], key="manage_jobs_divider")
    ui.element("p", children=["View, add, update, and delete job postings."], className="text-gray-600")

addBtn = ui.button("Add Job Posting", className="bg-blue-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"add_job")
if addBtn:
    st.switch_page('pages/Add_Job.py')

data = {} 
try:
    data = requests.get('http://api:4000/j/job-position/company/1').json()
    ui.element("h3", children=["Jobs"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  
    
def deleteJobPosting(job_id, job_title):
    try:
        response = requests.delete(f'http://api:4000/j/job-position/{job_id}')
        if response.status_code == 200:
            logger.info(f"Job Posting deleted: {job_id}")
            ui.alert_dialog(
            show=True, 
            title="Deleted Job Posting", 
            description=f"The job posting under the title {job_title} has been deleted.", 
            confirm_label="OK", 
            cancel_label="Cancel", 
            key=f"delete_dialog_{job_id}"
            )
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to delete job posting: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"delete_job_error_{job_id}"
            )
    except Exception as e:
        logger.error(f"Error deleting student {student_id}: {str(e)}")
        ui.element(
            "p",
            children=["Failed to delete student: Unknown error"],
            className="text-red-500",
            key=f"delete_student_error_{student_id}"
        )


def JobPostingCard(job):
    with ui.element("div", key=f"job_card_{job['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
         ui.element("h3", children=[f"{job['title']}"], className="text-xl font-bold text-gray-800", key=f"job_title_{job['id']}")
         ui.element("p", children=[f"Description: {job['description']}"], className="text-gray-600", key=f"job_desc_{job['id']}")
         ui.element("p", children=[f"Location: {job['location']}"], className="text-gray-600", key=f"job_location_{job['id']}")
         ui.element("p", children=[f"Desired Skills: {job['desired_skills']}"], className="text-gray-600", key=f"job_skills_{job['id']}")
         ui.element("p", children=[f"Targeted Majors: {job['targeted_majors']}"], className="text-gray-600", key=f"job_majors_{job['id']}")
         ui.element("p", children=[f"Number of Applicants: {job['num_applicants']}"], className="text-gray-600", key=f"job_applicants_{job['id']}")
         ui.element(
            "span",
            children=["Still Accepting: Yes" if job["still_accepting"] else "Still Accepting: No"],
            className="text-green-500" if job["still_accepting"] else "text-red-500",
            key=f"job_accepting_{job['id']}",
        )
         ui.element("p", children=[f"Posted At: {job['postedAt']}"], className="text-gray-400 text-sm", key=f"job_posted_{job['id']}")
         ui.element("p", children=[f"Updated At: {job['updatedAt']}"], className="text-gray-400 text-sm", key=f"job_updated_{job['id']}")
      

    col1, col2, col3, col4, col5, col6, col7, col8 = st.columns(8)

    with col1:
        updateBtn = ui.button("Update", className="bg-purple-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_job_{job['id']}")
        if updateBtn:
            st.session_state['updating_job_id'] = job['id']
            st.switch_page('pages/Update_Student.py')


    with col2:
        deleteBtn = ui.button("Delete", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"delete_job_{job['id']}")
        if deleteBtn:
            deleteJobPosting(job['id'], job['title'])
           


if data and isinstance(data, list):
    if data:
        for job in data:
            JobPostingCard(job)
    else:
        ui.element("h3", children=["No job postings found."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No job postings found."], className="text-xl font-bold text-gray-800")
