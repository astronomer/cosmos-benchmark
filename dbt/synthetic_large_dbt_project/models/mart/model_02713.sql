{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02161') }},
        {{ ref('model_02150') }}
)
select id, 'model_02713' as name from sources
