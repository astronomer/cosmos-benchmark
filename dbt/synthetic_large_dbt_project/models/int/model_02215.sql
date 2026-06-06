{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01158') }},
        {{ ref('model_00759') }}
)
select id, 'model_02215' as name from sources
