import logging
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

# Setup logger
logger = logging.getLogger(__name__)

# Display navigation links
SideBarLinks(show_home=True)

# Intro section
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_jobs_card"):
    ui.element("h2", children=["Check out reviews"], className="text-2xl font-bold text-gray-800", key="view_jobs_title")
    ui.element("div", children=["\n\n"], key="view_reviews_divider")
    ui.element("p", children=["Look at reviews for companies you desire."], className="text-gray-600")

# Fetch companies
companies = []
try:
    companies = requests.get('http://api:4000/c/company').json()
except Exception as e:
    logger.error(f"Error retrieving company data: {e}")
    companies = []

company_options = {company['name']: company["id"] for company in companies}
desired_company = ui.select(options=list(company_options.keys()), label="Select a company:")
desired_company_id = company_options.get(desired_company)

reviews_data = []
if desired_company_id:
    try:
        reviews_data = requests.get(f'http://api:4000/r/reviews/company/{desired_company_id}').json()
        logger.info(f"Retrieved reviews data for company ID: {desired_company_id}")
        logger.info(f"Reviews data: {reviews_data}")
    except Exception as e:
        logger.error(f"Error retrieving reviews data: {e}")
        reviews_data = []

def ReviewCard(review):
    with ui.element("div", key=f"review_card_{review['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element(
            "h3",
            children=[f"Rating: {review['rating']} / 5"],
            className="text-xl font-bold text-gray-800",
            key=f"review_rating_{review['id']}"
        )
        
        ui.element(
            "p",
            children=[review['review']],
            className="text-gray-600",
            key=f"review_text_{review['id']}"
        )

        ui.element("p", children=[f"Written by: {review['student_name']}"], className="text-gray-600", key=f"review_student_{review['id']}")


# Display review cards or a fallback message
if reviews_data and isinstance(reviews_data, list):
    if reviews_data:
        for review in reviews_data:
            ReviewCard(review)
    else:
        ui.element("h3", children=["No reviews available for this company"], className="text-xl font-bold text-gray-800")
else:
    logger.error("Failed to load review data or invalid company selected")
    ui.element("h3", children=["Failed to load review data or invalid company selected"], className="text-xl font-bold text-gray-800")
