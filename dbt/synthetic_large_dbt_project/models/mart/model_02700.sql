{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01866') }},
        {{ ref('model_01986') }},
        {{ ref('model_01910') }}
)
select id, 'model_02700' as name from sources
