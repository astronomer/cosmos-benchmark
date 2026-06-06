{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01745') }},
        {{ ref('model_02079') }}
)
select id, 'model_02721' as name from sources
