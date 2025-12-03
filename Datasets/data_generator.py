# Climate data generator for 7 countries: generates 500 days of consecutive climate data
# with temperature, humidity, precipitation, AQI, extreme weather events, and impact metrics

import csv
import random
from datetime import datetime, timedelta
import io

countries_config = {
    'Azerbaijan': {
        'prefix': 'AZ',
        'cities': ['Baku', 'Ganja', 'Sumqayit'],
        'temp_range': (-5, 35),
        'climate_class': ['BSk', 'Csa'],
        'climate_zone': ['Semi-arid', 'Mediterranean'],
        'biome': ['Steppe', 'Shrubland', 'Urban'],
        'city_params': {
            'Baku': {'population': 2300000, 'coastal': True, 'industrial': True, 'base_aqi': 85},
            'Ganja': {'population': 335000, 'coastal': False, 'industrial': False, 'base_aqi': 65},
            'Sumqayit': {'population': 345000, 'coastal': True, 'industrial': True, 'base_aqi': 90}
        }
    },
    'Georgia': {
        'prefix': 'GE',
        'cities': ['Tbilisi', 'Batumi', 'Kutaisi'],
        'temp_range': (-8, 32),
        'climate_class': ['Cfa', 'Cfb'],
        'climate_zone': ['Temperate', 'Humid subtropical'],
        'biome': ['Forest', 'Urban', 'Shrubland'],
        'city_params': {
            'Tbilisi': {'population': 1200000, 'coastal': False, 'industrial': False, 'base_aqi': 70},
            'Batumi': {'population': 155000, 'coastal': True, 'industrial': False, 'base_aqi': 55},
            'Kutaisi': {'population': 147000, 'coastal': False, 'industrial': False, 'base_aqi': 60}
        }
    },
    'Russia': {
        'prefix': 'RU',
        'cities': ['Moscow', 'Saint Petersburg', 'Kazan'],
        'temp_range': (-25, 30),
        'climate_class': ['Dfb', 'Dfc'],
        'climate_zone': ['Continental', 'Subarctic'],
        'biome': ['Forest', 'Taiga', 'Urban'],
        'city_params': {
            'Moscow': {'population': 12500000, 'coastal': False, 'industrial': True, 'base_aqi': 80},
            'Saint Petersburg': {'population': 5400000, 'coastal': False, 'industrial': False, 'base_aqi': 75},
            'Kazan': {'population': 1250000, 'coastal': False, 'industrial': False, 'base_aqi': 70}
        }
    },
    'Iran': {
        'prefix': 'IR',
        'cities': ['Tehran', 'Isfahan', 'Mashhad'],
        'temp_range': (-5, 42),
        'climate_class': ['BSk', 'BWk', 'Csa'],
        'climate_zone': ['Arid', 'Semi-arid'],
        'biome': ['Desert', 'Steppe', 'Urban'],
        'city_params': {
            'Tehran': {'population': 9000000, 'coastal': False, 'industrial': True, 'base_aqi': 95},
            'Isfahan': {'population': 2000000, 'coastal': False, 'industrial': False, 'base_aqi': 75},
            'Mashhad': {'population': 3200000, 'coastal': False, 'industrial': False, 'base_aqi': 80}
        }
    },
    'Turkey': {
        'prefix': 'TR',
        'cities': ['Ankara', 'Istanbul', 'Izmir'],
        'temp_range': (-8, 38),
        'climate_class': ['BSk', 'Csa', 'Cfb'],
        'climate_zone': ['Mediterranean', 'Temperate'],
        'biome': ['Shrubland', 'Forest', 'Urban'],
        'city_params': {
            'Ankara': {'population': 5700000, 'coastal': False, 'industrial': False, 'base_aqi': 75},
            'Istanbul': {'population': 15500000, 'coastal': True, 'industrial': True, 'base_aqi': 85},
            'Izmir': {'population': 4400000, 'coastal': True, 'industrial': False, 'base_aqi': 70}
        }
    },
    'Kazakhstan': {
        'prefix': 'KZ',
        'cities': ['Almaty', 'Astana', 'Shymkent'],
        'temp_range': (-30, 35),
        'climate_class': ['Dfa', 'BSk'],
        'climate_zone': ['Continental', 'Semi-arid'],
        'biome': ['Steppe', 'Grassland', 'Urban'],
        'city_params': {
            'Almaty': {'population': 2000000, 'coastal': False, 'industrial': False, 'base_aqi': 75},
            'Astana': {'population': 1200000, 'coastal': False, 'industrial': False, 'base_aqi': 70},
            'Shymkent': {'population': 1000000, 'coastal': False, 'industrial': False, 'base_aqi': 72}
        }
    },
    'Turkmenistan': {
        'prefix': 'TM',
        'cities': ['Ashgabat', 'Turkmenabat', 'Dashoguz'],
        'temp_range': (-5, 45),
        'climate_class': ['BWk'],
        'climate_zone': ['Arid', 'Desert'],
        'biome': ['Desert', 'Steppe'],
        'city_params': {
            'Ashgabat': {'population': 1000000, 'coastal': False, 'industrial': False, 'base_aqi': 80},
            'Turkmenabat': {'population': 280000, 'coastal': False, 'industrial': False, 'base_aqi': 65},
            'Dashoguz': {'population': 260000, 'coastal': False, 'industrial': False, 'base_aqi': 68}
        }
    }
}

def get_season(date):
    month = date.month
    if month in [12, 1, 2]:
        return 'Winter'
    elif month in [3, 4, 5]:
        return 'Spring'
    elif month in [6, 7, 8]:
        return 'Summer'
    else:
        return 'Autumn'

def calculate_heat_index(temp, humidity):
    if temp < 27:
        return max(-20, min(55, temp))
    c1, c2, c3 = -8.78469475556, 1.61139411, 2.33854883889
    c4, c5, c6 = -0.14611605, -0.012308094, -0.0164248277778
    c7, c8, c9 = 0.002211732, 0.00072546, -0.000003582
    T, H = temp, humidity
    HI = c1 + c2*T + c3*H + c4*T*H + c5*T*T + c6*H*H + c7*T*T*H + c8*T*H*H + c9*T*T*H*H
    return max(-20, min(55, round(HI, 1)))

def generate_country_data(country, config):
    end_date = datetime(2025, 9, 15)
    start_date = end_date - timedelta(days=499)
    
    rows = []
    duplicate_indices = random.sample(range(50, 450), 15)
    missing_value_indices = random.sample(range(500), 120)
    iso_date_indices = random.sample(range(500), 15)
    
    all_dates = [start_date + timedelta(days=i) for i in range(500)]
    
    for i in range(500):
        current_date = all_dates[i]
        
        if i in iso_date_indices:
            date_str = current_date.strftime('%Y-%m-%d')
        else:
            date_str = f"{current_date.day}/{current_date.month}/{current_date.year}"
        
        city = config['cities'][i % 3]
        city_params = config['city_params'][city]
        
        season = get_season(current_date)
        month = current_date.month
        
        base_temp = {
            'Winter': config['temp_range'][0] + 8,
            'Spring': (config['temp_range'][0] + config['temp_range'][1]) / 2 - 5,
            'Summer': config['temp_range'][1] - 5,
            'Autumn': (config['temp_range'][0] + config['temp_range'][1]) / 2
        }[season]
        
        warming_trend = (i / 500) * 1.5
        temp = base_temp + random.uniform(-5, 5) + warming_trend
        temp = max(-20, min(45, round(temp, 1)))
        
        base_humidity = 70 if city_params['coastal'] else 55
        humidity = round(base_humidity + random.uniform(-20, 30))
        humidity = max(0, min(105, humidity))
        
        precip_mult = 2 if city_params['coastal'] else 1
        precip = round(random.choices([0, random.uniform(0.1, 5), random.uniform(5, 30)],
                                     weights=[60, 30, 10])[0] * precip_mult, 1)
        
        aqi = city_params['base_aqi'] + random.uniform(-20, 40) + (i / 500) * 20
        aqi = max(0, min(500, int(aqi)))
        
        if month in [12, 1, 2]:
            events = ['None'] * 85 + ['Cold Wave'] * 5 + ['Storm'] * 5 + ['Flood'] * 3 + ['Blizzard'] * 2
        elif month in [6, 7, 8]:
            events = ['None'] * 85 + ['Heatwave'] * 6 + ['Drought'] * 5 + ['Storm'] * 3 + ['Wildfire'] * 1
        elif month in [3, 4, 5]:
            events = ['None'] * 88 + ['Storm'] * 5 + ['Flood'] * 5 + ['Dust Storm'] * 2
        else:
            events = ['None'] * 88 + ['Storm'] * 6 + ['Flood'] * 4 + ['Cold Wave'] * 2
        
        event = random.choice(events)
        
        if temp > 35 and month in [6, 7, 8]:
            event = random.choice(['Heatwave', 'None', 'None', 'Drought'])
        elif temp < -10 and month in [12, 1, 2]:
            event = random.choice(['Cold Wave', 'None', 'None', 'Blizzard'])
        
        heat_idx = calculate_heat_index(temp, humidity)
        
        wind_speed = round(random.uniform(2, 15) if event not in ['Storm', 'Blizzard'] else random.uniform(15, 35), 1)
        wind_dir = random.randint(0, 360)
        
        base_exposure_pct = random.uniform(0.05, 0.15)
        if event != 'None':
            event_multiplier = random.uniform(1.2, 3.5)
            exposure_pct = min(0.85, base_exposure_pct * event_multiplier)
        else:
            exposure_pct = base_exposure_pct
        pop_exposure = int(city_params['population'] * exposure_pct)
        
        if event == 'None':
            econ_impact = int(random.choices([0, random.uniform(1000, 50000)], 
                                            weights=[80, 20])[0])
        else:
            impact_levels = [
                (0, 15),
                (random.uniform(5000, 100000), 30),
                (random.uniform(100000, 500000), 30),
                (random.uniform(500000, 2000000), 20),
                (random.uniform(2000000, 5000000), 5)
            ]
            econ_impact = int(random.choices([x[0] for x in impact_levels], 
                                            weights=[x[1] for x in impact_levels])[0])
        
        base_infra = random.randint(35, 65)
        if event != 'None':
            event_effect = random.randint(-5, 35)
            infra_vuln = max(0, min(100, base_infra + event_effect))
        else:
            infra_vuln = base_infra
        
        row = [
            f"{config['prefix']}_{str(i+1).zfill(4)}",
            date_str,
            country,
            city,
            temp,
            humidity,
            precip,
            aqi,
            event,
            random.choice(config['climate_class']),
            random.choice(config['climate_zone']),
            random.choice(config['biome']),
            heat_idx,
            wind_speed,
            wind_dir,
            season,
            pop_exposure,
            econ_impact,
            infra_vuln
        ]
        
        if i in missing_value_indices:
            missing_cols = random.sample(range(4, 19), random.randint(1, 3))
            for col in missing_cols:
                row[col] = '' if random.random() > 0.5 else 'NA'
        
        if random.random() < 0.05:
            if isinstance(row[16], int):
                row[16] = f"{row[16]:,}"
            if isinstance(row[17], int):
                row[17] = f"{row[17]:,}"
        
        rows.append(row)
        
        if i in duplicate_indices:
            rows.append(row.copy())
    
    return rows

header = "Record ID,Date,Country,City,Temperature (°C),Humidity (%),Precipitation (mm),Air Quality Index (AQI),Extreme Weather Events,Climate Classification,Climate_Zone,Biome_Type,Heat_Index,Wind_Speed,Wind_Direction,Season,Population_Exposure,Economic_Impact_Estimate,Infrastructure_Vulnerability_Score"

files_created = []

for country, config in countries_config.items():
    filename = f"{country}_climate_500.csv"
    
    print(f"Generating {filename}...")
    
    rows = generate_country_data(country, config)
    
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(header.split(','))
        writer.writerows(rows)
    
    files_created.append(filename)
    print(f"✓ {filename} saved ({len(rows)} rows)")

print(f"\n{'='*60}")
print("All 7 CSV files generated successfully!")
print(f"{'='*60}")
print("\nFiles created in working directory:")
for filename in files_created:
    print(f"  • {filename}")