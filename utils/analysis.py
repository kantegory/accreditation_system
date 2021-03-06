import pandas as pd
from .db_manage import get_users_work_experience_by_blank_id


def merge_arr(arr):

    merged = []

    for i in range(len(arr)):
        for data in arr[i]:
            merged.append(data)

    return merged


def arr2df(arr): # переводит массив в датафрэйм

    df = pd.DataFrame(arr)
    df.answer = pd.to_numeric(df.answer)
    df = df.loc[df['questionType'] != 'job']
    return df


#считает 0,25; 0,5; 0,75 перцентили
def describe_percentile(df):

    df = df.groupby(['question']).describe()
    df = df.answer
    # df = df.T
    # df = df.drop(df.index[[0, 1, 2, 3, 7]])
    df = df.drop(columns=["count", "mean", "std", "min", "max"], axis=1)
    # df = df.T
    return df


# убирает аномалии
def free_anomaly(df1, df2): # df1 - df_describe, df2 - original
    for i in range(df1.shape[1]):

        if df1.iloc[0].iloc[i] > 1: # нижняя граница
            var1 = round(df1.iloc[0].iloc[i]) - 1
            df2.T.iloc[i] = df2.T.iloc[i].replace(int(var1), 0)

        print("iloc", df1.iloc[-1].iloc[i])

        if df1.iloc[-1].iloc[i] < 5: # верхняя граница
            var2 = round(df1.iloc[-1].iloc[i]) + 1
            df2.T.iloc[i] = df2.T.iloc[i].replace(int(var2), 0)

    return df2


# считает частоту попадания в высокий интервал
def freq(df1, df2): # df1 - describe, df2 - free_anomaly

    s = 0

    for i in range(df1.shape[0]):
        freq = len(df2[(df2.T.iloc[i] > df1.iloc[0].iloc[i] - 1) & (df2.T.iloc[i] < df1.iloc[-1].iloc[i] + 1)]) / 100
        s += freq

    return round(s / df1.shape[0], 3)


# определяет, выдавать ли сертификат
def sertificate(freq1, freq2, freq3, df2):

# наиболее весомые ответы дают работающие менее 2-х лет, на основе их выборки будут даны рекомендации
    s = ((freq1 + freq3) * 0.8 + freq2 * 1.2) / 3
    rec = df2.iloc[0].idxmin()
#выдача сертификата идет от оценки 4/5 = 0.8

    if s > 0.8:
        return 'Поздравляем! Вы прошли аккредитацию. Рекомендуем обратить внимание на следующую дисциплину: {}'.format(rec)
    else:
        return 'Вы не прошли аккредитацию. Обратите особое внимание на следующую дисциплину: {}'.format(rec)


#запускает все функции
def get_analysis_by_blank_id(blank_id):

    df_job2, df_job02, df_jobless = get_users_work_experience_by_blank_id(blank_id)

    if len(df_job2) > 2 and len(df_job02) > 2 and len(df_jobless) > 2:

        df_jobless = merge_arr(df_jobless)
        df_job02 = merge_arr(df_job02)
        df_job2 = merge_arr(df_job2)

        if len(df_job2) > 5 and len(df_job02) > 5 and len(df_jobless) > 5:
    
            df_jobless = arr2df(df_jobless)
            df_job02 = arr2df(df_job02)
            df_job2 = arr2df(df_job2)
            
            df1 = describe_percentile(df_jobless)
            df_jobless_anom = free_anomaly(df1, df_jobless)
            freq1 = freq(df1, df_jobless_anom)

            df2 = describe_percentile(df_job02)
            df_job02_anom = free_anomaly(df2, df_job02)
            freq2 = freq(df2, df_job02_anom)
            
            df3 = describe_percentile(df_job2)
            df_job2_anom = free_anomaly(df3, df_job2)
            freq3 = freq(df3, df_job2_anom)

            result = sertificate(freq1, freq2, freq3, df2) # df2 - потому что работающее менее 2-х лет дают наиболее значимые ответы;

            return result

    else:

        return "Слишком мало данных"
