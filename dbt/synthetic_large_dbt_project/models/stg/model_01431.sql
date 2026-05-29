{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00432') }},
        {{ ref('model_00662') }}
)
select id, 'model_01431' as name from sources
