{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01093') }},
        {{ ref('model_01167') }}
)
select id, 'model_02138' as name from sources
