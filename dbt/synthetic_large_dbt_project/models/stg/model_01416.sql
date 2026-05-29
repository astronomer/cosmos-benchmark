{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00399') }},
        {{ ref('model_00330') }},
        {{ ref('model_00586') }}
)
select id, 'model_01416' as name from sources
