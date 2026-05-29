{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00401') }},
        {{ ref('model_00302') }},
        {{ ref('model_00661') }}
)
select id, 'model_00751' as name from sources
