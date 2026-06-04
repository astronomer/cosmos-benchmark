{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01356') }},
        {{ ref('model_00880') }}
)
select id, 'model_01806' as name from sources
