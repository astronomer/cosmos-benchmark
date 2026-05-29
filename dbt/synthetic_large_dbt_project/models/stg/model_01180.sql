{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00495') }}
)
select id, 'model_01180' as name from sources
