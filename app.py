import pandas as pd  # pip install pandas openpyxl
import plotly.express as px  # pip install plotly-express
import streamlit as st  # pip install streamlit

# emoji cheat-sheet https://www.webfx.com/tools/emoji-cheat-sheet/
st.set_page_config(page_title="Fred Dashboard",
                   page_icon=":bar_chart:",
                   layout="wide"
)

# ---- READ EXCEL ----
@st.cache
def get_data_from_excel():
    df = pd.read_excel(
            io="supermarkt_sales.xlsx",
            engine="openpyxl",
            sheet_name="Sales",
            skiprows=3,
            usecols="B:R",
            nrows=1000,
        )
        #  Add an hour column to dataframe
    df['hour'] = pd.to_datetime(df['Time'], format="%H:%M:%S").dt.hour
    return df
df = get_data_from_excel()
# ---- SIDEBAR ----
st.sidebar.header("Please filter here:")

city = st.sidebar.multiselect(
    "select the city: ",
    options=df['City'].unique(),
    default=df['City'].unique()
)

customer_type = st.sidebar.multiselect(
    "select the customer type: ",
    options=df['Customer_type'].unique(),
    default=df['Customer_type'].unique()
)

gender = st.sidebar.multiselect(
    "select the gender: ",
    options=df['Gender'].unique(),
    default=df['Gender'].unique()
)

df_selection = df.query(
    "City == @city & Customer_type == @customer_type & Gender == @gender"
)

# st.dataframe(df_selection)

#  --- MAINPAGE ---
st.title(":bar_chart: Sales Dashboard")
st.markdown("###")

# TOP KPI's

total_sales = int(df_selection["Total"].sum())
average_rating = round(df_selection["Rating"].mean(), 1)
start_rating = ":star:" * int(round(average_rating, 0))
average_sale_by_transaction = round(df_selection["Total"].mean(), 2)

# some comment
left_column, middle_column, right_column = st.columns(3)
with left_column:
    st.subheader("Total Sales:")
    st.subheader(f"US $ {total_sales:,}")
with middle_column:
    st.subheader("Average Rating:")
    st.subheader(f"{average_rating} {start_rating}")
with right_column:
    st.subheader("Average Sales Per Transaction:")
    st.subheader(f"{average_sale_by_transaction}")

st.markdown("---")

# Sales by product line [Bar chart]

sales_by_product_line = (
    df_selection.groupby(by=["Product line"]).sum()[["Total"]].sort_values(by="Total")
)

fig_product_sales = px.bar(
 sales_by_product_line,
 x = "Total",
 y = sales_by_product_line.index,
 orientation = "h",
 title = "<b>Sales by product line</b>",
 color_discrete_sequence=["#0083D8"] * len(sales_by_product_line),
 template="plotly_white"
)

fig_product_sales.update_layout(
    plot_bgcolor="rgba(0,0,0,0)",
    xaxis=(dict(showgrid=False))
)
# st.plotly_chart(fig_product_sales)

# Sales by hour [Bar chart]

sales_by_hour = df_selection.groupby(by=["hour"]).sum()[['Total']]

fig_hourly_sales = px.bar(
 sales_by_hour,
 x = sales_by_hour.index,
 y = "Total",
 title = "<b>Sales by hour</b>",
 color_discrete_sequence=["#0083D8"] * len(sales_by_hour),
 template="plotly_white"
)

fig_hourly_sales.update_layout(
    plot_bgcolor="rgba(0,0,0,0)",
    xaxis=(dict(tickmode="linear")),
    yaxis=(dict(showgrid=False)),
)

left_column, right_column = st.columns(2)
left_column.plotly_chart(fig_hourly_sales, use_container_width=True)
right_column.plotly_chart(fig_product_sales, use_container_width=True)

hide_st_style = """
    <style>
    #MainMenu {visibility: hidden;}
    footer {visibility: hidden;}
    header {visibility: hidden;}
    </style>
"""
st.markdown(hide_st_style, unsafe_allow_html=True)
