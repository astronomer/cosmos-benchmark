{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00829') }},
        {{ ref('model_01128') }}
)
select id, 'model_01551' as name from sources
