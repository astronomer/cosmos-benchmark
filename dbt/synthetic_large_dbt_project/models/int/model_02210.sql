{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01024') }}
)
select id, 'model_02210' as name from sources
