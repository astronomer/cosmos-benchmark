{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01576') }},
        {{ ref('model_02043') }}
)
select id, 'model_02858' as name from sources
