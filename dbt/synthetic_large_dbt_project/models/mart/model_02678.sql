{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01813') }},
        {{ ref('model_01747') }},
        {{ ref('model_01915') }}
)
select id, 'model_02678' as name from sources
