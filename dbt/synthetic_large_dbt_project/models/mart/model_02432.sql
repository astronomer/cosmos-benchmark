{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01967') }},
        {{ ref('model_02179') }},
        {{ ref('model_01598') }}
)
select id, 'model_02432' as name from sources
