{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02200') }},
        {{ ref('model_02215') }}
)
select id, 'model_02516' as name from sources
