{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01445') }}
)
select id, 'model_01948' as name from sources
