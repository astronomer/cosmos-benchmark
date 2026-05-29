{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00895') }},
        {{ ref('model_00751') }}
)
select id, 'model_01878' as name from sources
