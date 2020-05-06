import cx_Oracle
import pandas as pd

p_username = "DIVA"
p_password = "DIVA"
p_host = "localhost"
p_service = "orclpdb.myfiosgateway.com"
p_port = "1521"

con_prov_drill = cx_Oracle.connect(user=p_username, password=p_password, dsn=p_host + "/" + p_service + ":" + p_port,
                                   encoding="UTF-8",
                                   nencoding="UTF-8")
country_name = 'CHILE'
df_prov = pd.read_sql_query('''SELECT *  FROM TASTER_VARIETY_VIEW''', con_prov_drill)

drill_data = {}
for index, row in df_prov.iterrows():
    each_data = {}
    if drill_data.get(row['TASTER_NAME']) is not None:
        each_data = drill_data[row['TASTER_NAME']]
    child = {}
    if (drill_data.get(row['TASTER_NAME']) is None) or (drill_data.get(row['TASTER_NAME']).get('children') is None):
        each_data['children'] = {}
    elif drill_data.get(row['TASTER_NAME']).get('children').get(row['VARIETY']) is not None:
        child = drill_data.get(row['TASTER_NAME']).get('children').get(row['VARIETY'])
    each_data['children'][row['VARIETY']] = child
    child['variety'] = row['VARIETY']
    child['wine_cnt'] = row['WINE_CNT']
    grandchild = {}
    if (drill_data.get(row['TASTER_NAME']) is None) or (drill_data.get(row['TASTER_NAME']).get('children') is None) or (
            drill_data.get(row['TASTER_NAME']).get('children').get(row['VARIETY']).get('children') is None):
        each_data['children'][row['VARIETY']]['children'] = {}
    elif drill_data.get(row['TASTER_NAME']).get('children').get(row['VARIETY']).get('children').get(
            row['TITLE']) is not None:
        grandchild = drill_data.get(row['TASTER_NAME']).get('children').get(row['VARIETY']).get('children').get(
            row['TITLE'])
    each_data['children'][row['VARIETY']]['children'][row['TITLE']] = grandchild
    grandchild['title'] = row['TITLE']
    grandchild['pointsrank'] = row['POINTSRANK']
    grandchild['points'] = row['POINTS']
    each_data['taster_name'] = row['TASTER_NAME']
    drill_data[row['TASTER_NAME']] = each_data


def processforcetreedata(data):
    treeData = []

    for taster in data:
        tasterData = {
            'name': taster,
            'children': []
        }
        i = 0
        for variety in data[taster]['children']:
            tasterData['children'].append({
                'name': data[taster]['children'][variety]['variety'],
                'count': data[taster]['children'][variety]['wine_cnt'],
                'children': []
            })

            for title in data[taster]['children'][variety]['children']:
                tasterData['children'][i]['children'].append({
                    'name': data[taster]['children'][variety]['children'][title]['title'],
                    'value': data[taster]['children'][variety]['children'][title]['points'],
                    'pointsrank': data[taster]['children'][variety]['children'][title]['pointsrank']
                })

            i = i + 1

        treeData.append(tasterData)

    return treeData


processforcetreedata(drill_data)
