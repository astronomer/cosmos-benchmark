{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00628') }},
        {{ ref('model_00206') }}
)
select id, 'model_00806' as name from sources
