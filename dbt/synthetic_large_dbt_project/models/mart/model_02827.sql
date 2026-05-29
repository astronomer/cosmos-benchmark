{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01780') }},
        {{ ref('model_02043') }},
        {{ ref('model_01900') }}
)
select id, 'model_02827' as name from sources
